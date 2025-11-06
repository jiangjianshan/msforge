# -*- coding: utf-8 -*-
#
#  Copyright (c) 2024 Jianshan Jiang
#
import os
from graphlib import TopologicalSorter, CycleError
from collections import deque
from pathlib import Path
from rich.tree import Tree
from rich.text import Text

from mpt.config import LibraryConfig
from mpt.log import RichLogger
from mpt.plat import PlatformManager
from mpt.view import RichTable, RichPanel


class DependencyResolver:
    """
    Advanced dependency resolution system with support for required and optional dependencies.

    Provides comprehensive dependency management including dependency parsing, graph construction,
    topological sorting, visualization, and resolution with build integration. Handles complex
    dependency relationships and circular dependency detection.
    """

    @classmethod
    def _normalize_node_name(cls, node_name: str) -> str:
        """
        Normalize node name by removing architecture suffix while preserving dependency type.

        Handles the following formats:
        - "library" -> "library"
        - "library:required" -> "library:required"
        - "library:x64" -> "library"
        - "library:required:x64" -> "library:required"

        Args:
            node_name: Full node name with optional type and architecture suffixes

        Returns:
            str: Node name with architecture suffix removed but dependency type preserved
        """
        parts = node_name.split(':')
        # If no colons present, return the name as is
        if len(parts) == 1:
            return node_name
        # If the last part is an architecture identifier, remove it
        if parts[-1] in ['x86', 'x64', 'arm64']:
            # Remove the architecture suffix and rejoin the remaining parts
            return ':'.join(parts[:-1])
        else:
            # No architecture suffix found, return the original name
            return node_name

    @staticmethod
    def parse_dependency_name(dep_name):
        """
        Parse dependency specification into library name, dependency type, and architecture.

        Supports the following input formats:
        - "library" -> (library, None, None)
        - "library:required" -> (library, "required", None)
        - "library:x64" -> (library, None, "x64")
        - "library:required:x64" -> (library, "required", "x64")

        Args:
            dep_name (str): Dependency specification string to parse

        Returns:
            tuple: (library_name, dependency_type, architecture) triple
        """
        parts = dep_name.split(':')
        if len(parts) == 1:
            # Format: "library"
            return parts[0], None, None
        elif len(parts) == 2:
            # Determine if the second part is architecture or dependency type
            if parts[1] in ['x86', 'x64', 'arm64']:
                # Format: "library:arch"
                return parts[0], None, parts[1]
            else:
                # Format: "library:type"
                return parts[0], parts[1], None
        elif len(parts) == 3:
            # Format: "library:type:arch"
            return parts[0], parts[1], parts[2]
        else:
            # Invalid format - log warning and return original name
            RichLogger.warning(f"Invalid dependency format: {dep_name}")
            return dep_name, None, None

    @staticmethod
    def get_dependencies(lib_name, dep_type=None, arch=None):
        """
        Retrieve dependencies for a library with type and architecture processing.

        Loads library configuration and extracts dependency information, supporting
        filtering by dependency type and appending architecture information when needed.

        Args:
            lib_name (str): Name of the library to query for dependencies
            dep_type (str): Optional dependency type filter ('required' or 'optional')
            arch (str): Optional architecture to append to dependencies

        Returns:
            list: List of processed dependency specifications
        """
        config = LibraryConfig.load(lib_name)
        if not config:
            RichLogger.error(f"[[bold cyan]{lib_name}[/bold cyan]] Failed to load library configuration")
            return []

        deps = config.get('dependencies', {}) or {}

        if dep_type is None:
            # Combine both required and optional dependencies
            required_deps = deps.get('required', []) or []
            optional_deps = deps.get('optional', []) or []
            raw_deps = required_deps + optional_deps
        else:
            # Return only dependencies of the specified type
            raw_deps = deps.get(dep_type, []) or []

        all_deps = []
        # Process each dependency to add architecture information if needed
        for dep in raw_deps:
            processed_dep = DependencyResolver._process_dependency(dep, arch)
            all_deps.append(processed_dep)

        return all_deps

    @staticmethod
    def _process_dependency(dep, arch):
        """
        Process a single dependency by appending architecture information if needed.

        If an architecture is specified and the dependency doesn't already have one,
        the architecture suffix will be appended to the dependency specification.

        Args:
            dep (str): Original dependency specification
            arch (str): Architecture to append if dependency doesn't have one

        Returns:
            str: Processed dependency with architecture information
        """
        if not arch:
            return dep

        # Parse the dependency to check if it already has architecture information
        dep_name, dep_type, dep_arch = DependencyResolver.parse_dependency_name(dep)

        # If dependency already has architecture, return as is
        if dep_arch:
            return dep

        # Append architecture to the dependency specification
        if dep_type:
            # Format: {library_name}:{dependency_type}:{architecture}
            return f"{dep_name}:{dep_type}:{arch}"
        else:
            # Format: {library_name}:{architecture}
            return f"{dep_name}:{arch}"

    @staticmethod
    def build_tree(triplet, root):
        """
        Construct a complete dependency graph starting from a root node with platform filtering.

        Uses breadth-first search to traverse dependencies and builds a graph that includes
        only libraries supported on the target platform.

        Args:
            triplet (str): Target triplet for platform filtering (e.g., "x64-windows")
            root (str): Root dependency specification to start graph construction

        Returns:
            dict: Dependency graph filtered by platform support
        """
        graph = {}
        visited = set()
        queue = deque([root])

        try:
            # Extract target OS from triplet (e.g., "windows" from "x64-windows")
            target_os = triplet.split('-')[1]

            while queue:
                current_node = queue.popleft()
                if current_node in visited:
                    continue

                visited.add(current_node)
                lib_name, dep_type, arch = DependencyResolver.parse_dependency_name(current_node)

                # Check if library supports the target platform
                config = LibraryConfig.load(lib_name)
                if config:
                    supports = config.get('supports', [])
                    if supports and target_os not in supports:
                        RichLogger.info(f"Skipping {lib_name}: not supported on {target_os}")
                        continue  # Skip unsupported libraries entirely

                # Get dependencies for the current node
                dependencies = DependencyResolver.get_dependencies(lib_name, dep_type, arch)
                graph[current_node] = set(dependencies)

                # Add dependencies to the queue for further processing
                for dep in dependencies:
                    if dep not in visited:
                        queue.append(dep)

        except Exception as e:
            RichLogger.exception(f"Failed to build dependency tree for root '{root}': {str(e)}")
            raise

        return graph

    @staticmethod
    def topological_sort(root, graph):
        """
        Perform topological sorting on a dependency graph to determine build order.

        Uses Kahn's algorithm (via graphlib.TopologicalSorter) to establish a valid
        processing order that respects all dependency constraints. Detects and reports
        circular dependencies that would prevent valid ordering.

        Args:
            root (str): Root library name for logging and identification
            graph (dict): Dependency graph to sort

        Returns:
            list: Topologically sorted list of node names in valid processing order

        Raises:
            CycleError: If a circular dependency is detected in the graph
        """
        try:
            # Create topological sorter and get static order
            ts = TopologicalSorter(graph)
            order = list(ts.static_order())

            # Create and display order table
            order_table = RichTable.create(
                title=f"[[bold cyan]{root}[/bold cyan]] Topological Order",
                show_header=True,
                header_style="bold cyan"
            )
            RichTable.add_column(order_table, "Step", style="cyan", justify="right", no_wrap=True)
            RichTable.add_column(order_table, "Library", style="bold yellow")

            # Add each node to the table with its position in the order
            for i, node in enumerate(order, 1):
                RichTable.add_row(order_table, str(i), node)

            # Render the table
            RichTable.render(order_table)

            return order

        except CycleError as e:
            RichLogger.exception(f"[[bold cyan]{root}[/bold cyan]] Cycle detected: {str(e)}")
            raise

    @staticmethod
    def render_tree(root, graph):
        """
        Generate and display a visual representation of the dependency tree.

        Creates a rich-formatted tree structure using Unicode characters and color
        coding to visualize dependency relationships. Uses different icons for nodes
        with and without children to improve readability.

        Args:
            root (str): Root library name for tree labeling
            graph (dict): Dependency graph to visualize
        """
        RichLogger.info(f"[[bold cyan]{root}[/bold cyan]] Rendering dependency tree with [bold yellow]{len(graph)}[/bold yellow] nodes")

        # Create the root node of the tree
        tree = Tree(f"🌳 [bold green]{root}[/bold green]", guide_style="dim")
        visited = set()
        queue = deque([(root, tree, 0)])

        # Use BFS to build the visual tree structure
        while queue:
            node_name, parent_node, depth = queue.popleft()
            if node_name in visited:
                continue
            visited.add(node_name)

            dependencies = graph.get(node_name, set())
            for dep_node in dependencies:
                # Check if the dependency node has children
                has_children = dep_node in graph and graph[dep_node] and dep_node not in visited
                # Choose appropriate icon based on whether node has children
                icon = "🌿" if has_children else "🍃"
                display_name = f"{icon} {dep_node}"
                # Create child node in the visual tree
                node = parent_node.add(Text(display_name, style="bold" if depth < 2 else ""))

                # If the node has children, add it to the queue for expansion
                if has_children:
                    queue.append((dep_node, node, depth + 1))

        # Display the completed tree
        RichLogger.print(tree)

    @staticmethod
    def resolve(triplet, root, build=False):
        """
        Complete dependency resolution process with optional build execution.

        Performs the full dependency resolution workflow: builds the dependency graph,
        renders the visual tree, performs topological sorting, and optionally executes
        the build process for all resolved dependencies.

        Args:
            triplet: Target triplet (e.g., x64-windows) for platform filtering and build operations
            root (str): Root library specification to resolve dependencies for
            build (bool): If True, execute build process for resolved dependencies

        Returns:
            bool: True if resolution (and build if requested) completed successfully, False otherwise
        """
        # Build the complete dependency graph
        graph = DependencyResolver.build_tree(triplet, root)
        # Render visual representation of the dependency tree
        DependencyResolver.render_tree(root, graph)
        # Get topological order for processing
        order = DependencyResolver.topological_sort(root, graph)

        # Execute build process if requested
        if build:
            for node_name in order:
                lib_name, dep_type, arch = DependencyResolver.parse_dependency_name(node_name)
                config = LibraryConfig.load(lib_name)
                if not config:
                    RichLogger.error(f"[[bold cyan]{root}[/bold cyan]] Failed to load configuration for [bold cyan]{lib_name}[/bold cyan]")
                    return False

                # Determine the appropriate triplet for building
                from mpt.build import BuildManager
                if arch:
                    lib_triplet = PlatformManager.get_triplet(arch)
                else:
                    lib_triplet = triplet

                # Build the library
                success = BuildManager.build_library(lib_triplet, DependencyResolver._normalize_node_name(node_name), config)
                if not success:
                   RichLogger.error(f"[[bold cyan]{root}[/bold cyan]] Build failed for [bold cyan]{node_name}[/bold cyan]")
                   return False

        return True

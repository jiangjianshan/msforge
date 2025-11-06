import platform


class PlatformManager:
    @classmethod
    def get_triplet(cls, arch):
        """
        Generate a triplet string in the format: {arch}-{os}
        
        Args:
            arch (str): Architecture identifier (e.g., 'x86_64', 'aarch64', 'armv7')
        
        Returns:
            str: Triplet string in the format {arch}-{os}
        """
        os = platform.system().lower()
        # Combine architecture and OS to form the triplet
        triplet = f"{arch}-{os}"
        return triplet

$VARIANTS = @(
    @{
        _metadata = @{
            platforms = 'linux/386,linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64,linux/s390x'
        }
        tag = 'v1.3'
        tag_as_latest = $true
    }
)

# Docker image variants' definitions (shared)
$VARIANTS_SHARED = @{
    buildContextFiles = @{
        templates = @{
            'Dockerfile' = @{
                common = $true
                passes = @(
                    @{
                        variables = @{}
                    }
                )
            }
        }
        copies = @(
            'assets'
        )
    }
}

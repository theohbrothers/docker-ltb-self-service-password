$local:VERSIONS = @(
    '1.3'
)
$VARIANTS = @(
    foreach ($v in $local:VERSIONS) {
        @{
            _metadata = @{
                package_version = $v
                platforms = 'linux/386,linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64,linux/s390x'
                job_group_key = $v
            }
            tag = "v$v"
            tag_as_latest = if ($v -eq $local:VERSIONS[0] ) { $true } else { $false }
        }
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

# Contibuting

## FAQ

### How to update Hypertrack SDK Version and make a release?

1. Update SDK version constant
    - Android 
        - src/android/HypertrackPlugin.gradle
            - HYPERTRACK_SDK_VERSION
    - iOS
        - plugin.xml
            - `<platform name="ios">`
                - `<pod name="HyperTrack" version="**version**"/>`

2. Update wrapper version
    - package.json
        - version
    - plugin.xml
        - version

3. Update CHANGELOG
4. Update README badge
5. Create a version tag
6. Commit and push
7. Create a release
    - Release title - version
8. npm publish

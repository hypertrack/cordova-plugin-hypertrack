# Contibuting

## FAQ

### How to update Hypertrack SDK Version and make a release?

1. Update SDK version constant
    - Android 
        - [src/android/HypertrackPlugin.gradle](src/android/HypertrackPlugin.gradle)
            - HYPERTRACK_SDK_VERSION
    - iOS
        - [plugin.xml](plugin.xml)
            - `<platform name="ios">`
                - `<pod name="HyperTrack" version="**version**"/>`

2. Update wrapper version
    - [package.json](package.json)
        - version
    - [plugin.xml](plugin.xml)
        - version

3. Update [CHANGELOG](CHANGELOG.md)
   
4. Update the [README](README.md) badge

5. Do the release dry run with `just release` and verify that the release is correct (checklist is in the command output)
   
6. Commit and merge to master

7. Create and push a new version tag

8. Create a Github repo release
   - Release title should be the current version tag

9. Run `npm publish` to publish the package to npm

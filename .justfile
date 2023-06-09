release:
    npm publish --dry-run
    @echo "THIS IS DRY RUN. Check if everything is ok and then run 'npm publish'. Checklist:"
    @echo "\t- check the release steps in CONTRIBUTING"

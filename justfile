hooks:
    chmod +x .githooks/pre-push
    git config core.hooksPath .githooks

release: hooks
    npm publish --dry-run
    @echo "THIS IS DRY RUN. Check if everything is ok and then run 'npm publish'. Checklist:"
    @echo "\t- check the release steps in CONTRIBUTING"

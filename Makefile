download-cc:
	npx gitpick automazeio/ccpm/.claude .claude-tmp -b 084489debb797d78471340299e5b88b31a419206 -o && mv .claude-tmp/.claude .claude && rm -rf .claude-tmp
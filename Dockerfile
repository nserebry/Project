# From https://github.com/nodejs/docker-node/blob/master/4.4/onbuild/Dockerfile
FROM node:4.4.4-onbuild

# Install mocha globally
RUN npm install -g mocha mocha-junit-reporter

CMD ["./scripts/test_runner.sh"]

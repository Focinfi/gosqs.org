FROM daocloud.io/node:7.8.0-onbuild
ADD . ~/
WORKDIR ~
EXPOSE 8081
CMD ["npm", "start"]

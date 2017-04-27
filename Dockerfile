FROM daocloud.io/node:0.10-onbuild
ADD . ~/
WORKDIR ~
EXPOSE 8081
CMD ["npm run build", "npm run start"]

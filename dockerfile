FROM node as build
WORKDIR /app
COPY ./flask-app flask-app
RUN if [ ! -d app/flask-app/node_modules ]; then npm install --prefix flask-app; else echo "skip install"; fi
RUN npm run build --prefix flask-app

FROM alpine:3.11.5 as runn
WORKDIR /app
RUN apk add --no-cache python2 && python -m ensurepip --upgrade 
COPY --from=build /app/flask-app flask-app
COPY ./flask-app/app.py ./flask-app/app.py
COPY ./flask-app/requirements.txt ./flask-app/requirements.txt
COPY ./utils utils
RUN pip install -r flask-app/requirements.txt 
EXPOSE 5000
ENTRYPOINT ["python", "flask-app/app.py"]
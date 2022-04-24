helm upgrade --install --atomic \
      --create-namespace --namespace flask-api \
      -f flask-api/values.yaml \
      flask-api flask-api

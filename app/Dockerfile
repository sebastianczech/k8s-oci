FROM python:3

WORKDIR /usr/src/app

# pip freeze > requirements.txt
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5080

CMD [ "python", "./app.py" ]
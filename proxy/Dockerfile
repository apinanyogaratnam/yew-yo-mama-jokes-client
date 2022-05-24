FROM python:3.10.4-alpine3.15

WORKDIR /app

COPY requirements.txt .
COPY proxy.py .

# install python dependencies
RUN pip3 install -r requirements.txt

# run the proxy server
CMD ["python3", "proxy.py"]

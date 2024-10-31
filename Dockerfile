
FROM python:3.9-slim


WORKDIR /app


COPY . /app


RUN pip install --no-cache-dir -r requirements.txt


EXPOSE 8000


ENV POSTGRES_DB=bankaccount_db
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=password
ENV POSTGRES_HOST=db
ENV POSTGRES_PORT=5432

CMD ["python", "bankaccounts_manager.py"]

docker pull postgres:17.4-alpine3.21
docker run -e POSTGRES_PASSWORD=Bonjour123! -p 5432:5432 -d postgres:17.4-alpine3.21
psql -U postgres -h localhost -d patent
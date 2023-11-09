# docker exec -it postgres bash
# psql
# \l
# \c DB_NAME
# \dt
postgres:
	docker run --name postgres -p 5431:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=postgres -d postgres:9.6

createdb:
	docker exec -it postgres createdb --username=root --owner=root go_bank

dropdb:
	docker exec -it postgres dropdb go_bank

upgradedb:
	migrate -path database/migration -database postgresql://root:postgres@localhost:5431/go_bank?sslmode=disable -verbose up

downgradedb:
	migrate -path database/migration -database postgresql://root:postgres@localhost:5431/go_bank?sslmode=disable -verbose down

generatesqlc:
	docker run --rm -v "%cd%:/src" -w /src sqlc/sqlc generate

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

.PHONY: postgres createdb dropdb
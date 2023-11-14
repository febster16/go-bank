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

# migrate create -ext sql -dir database/migration -seq add_users
upgradedb:
	migrate -path database/migration -database postgresql://root:postgres@localhost:5431/go_bank?sslmode=disable -verbose up

upgradedb1:
	migrate -path database/migration -database postgresql://root:postgres@localhost:5431/go_bank?sslmode=disable -verbose up 1

downgradedb:
	migrate -path database/migration -database postgresql://root:postgres@localhost:5431/go_bank?sslmode=disable -verbose down

downgradedb1:
	migrate -path database/migration -database postgresql://root:postgres@localhost:5431/go_bank?sslmode=disable -verbose down 1

generatesqlc:
	docker run --rm -v "%cd%:/src" -w /src sqlc/sqlc generate

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

start-app:
	go run main.go

mockdb:
	mockgen -package mockdb -destination database/mock/store.go github.com/febster16/go-bank/database/sqlc Store

clean-test-cache:
	go clean -testcache

.PHONY: postgres createdb dropdb upgradedb downgradedb sqlc test start-app upgradedb1 downgradedb1
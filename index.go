package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"log"
	"net/http"

	"github.com/gorilla/mux"
	_ "github.com/lib/pq"
)

const (
	DB_USER     = "postgres"
	DB_PASSWORD = ""
	DB_NAME     = "devbox"
)

// db setup
func setupDB() *sql.DB {
	dbinfo := fmt.Sprintf("user=%s password=%s dbname=%s sslmode=disable", DB_USER, DB_PASSWORD, DB_NAME)
	// db, err := sql.OpenDB("postgres", dbinfo)
	db, err := sql.Open("postgres", dbinfo)
	if err != nil {
		log.Fatal(err)
	}

	// Set the maximum number of concurrently idle connections to 5. Setting this
	// to less than or equal to 0 will mean that no idle connections are retained.
	db.SetMaxIdleConns(5)
	// printMessage("Connected to db...")
	return db
}

// type Movie struct {
// 	MovieID   string `json:"movieid"`
// 	MovieName string `json:"moviename"`
// }

type JsonResponse struct {
	Type    string    `json:"type"`
	Data    *sql.Rows `json:"data"`
	Message string    `json:"message"`
}

func main() {

	// Init the mux router
	r := mux.NewRouter()

	// Route handles & endpoints

	r.HandleFunc("/products/{id:[0-9]+}", ProductHandler).Methods("GET")
	r.HandleFunc("/products/{id:[0-9]+}/related", RelatedHandler).Methods("GET")
	// r.HandleFunc("/products/{id:[0-9]+}/styles", StyleHandler).Methods("GET")

	// serve the app
	fmt.Println("Server at 3000")
	log.Fatal(http.ListenAndServe(":3000", r))
}

// Function for handling messages
func printMessage(message string) {
	fmt.Println("")
	fmt.Println(message)
	fmt.Println("")
}

func checkErr(err error) {
	if err != nil {
		panic(err)
	}
}

func ProductHandler(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	w.WriteHeader(http.StatusOK)
	fmt.Fprintf(w, "Product Id: %v\n", vars["id"])
}

func RelatedHandler(w http.ResponseWriter, r *http.Request) {
	db := setupDB()
	vars := mux.Vars(r)
	// printMessage("Getting related...")

	// rows, err := db.Query("SELECT array_agg(related_product_id) FROM related WHERE current_product_id=$1", vars["id"])
	rows, err := db.Query("SELECT * FROM products WHERE id=$1", vars["id"])

	// check errors
	checkErr(err)
	// printMessage(fmt.Sprint(rows))
	var response = JsonResponse{Type: "success", Data: rows}
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(response)
}

// TODO CHANGE db.Open on line 24 with proper command maybe Pool or close the db connection after each query?

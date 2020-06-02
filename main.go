package main

import (
	"encoding/json"
	"log"
	"net/http"
	"os"
	"time"
)

const Version = "v1.0.1"

var (
	Port      string = "4242"
	BuildInfo string = ""
)

type Status struct {
	Build   string
	Env     string
	Version string
}

type handler struct{}

func NewHandler() *handler {
	return &handler{}
}

func (h *handler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	status := Status{
		Build:   BuildInfo,
		Version: Version,
		Env:     os.Getenv("APP_ENV"),
	}

	w.Header().Add("Content-Type", "application/json")
	enc := json.NewEncoder(w)
	if err := enc.Encode(status); err != nil {
		log.Fatal(err)
	}
}

func main() {
	s := &http.Server{
		Addr:           ":" + Port,
		Handler:        NewHandler(),
		ReadTimeout:    5 * time.Second,
		WriteTimeout:   5 * time.Second,
		MaxHeaderBytes: 1 << 20,
	}

	log.Printf("[INFO] Starting server on port %s", Port)
	log.Fatal(s.ListenAndServe())
}

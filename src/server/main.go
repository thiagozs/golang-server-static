package main

import (
	"flag"
	"fmt"
	"net/http"
	"os"
	"path/filepath"
	"strings"

	"github.com/go-chi/chi"
	"github.com/go-chi/chi/middleware"
)

var (
	port   int
	folder string
	root   string
)

func init() {
	flag.IntVar(&port, "port", 3000, "port to listen")
	flag.StringVar(&folder, "folder", ".", "folder to serve")
	flag.StringVar(&root, "root", "/", "root of url")
}

func main() {
	flag.Parse()

	r := chi.NewRouter()
	r.Use(middleware.DefaultCompress) //gzip
	r.Use(middleware.RequestID)       //idserver
	r.Use(middleware.Logger)          //stdout
	r.Use(middleware.Recoverer)

	workDir, _ := os.Getwd()
	filesDir := filepath.Join(workDir, folder)
	fileServer(r, root, http.Dir(filesDir))

	fmt.Printf("Server listening port: %v;\nServe folder: %v\n", port, folder)
	host := fmt.Sprintf(":%v", port)
	http.ListenAndServe(host, r)

}

func fileServer(r chi.Router, path string, root http.FileSystem) {
	if strings.ContainsAny(path, "{}*") {
		panic("FileServer does not permit URL parameters.")
	}

	fs := http.StripPrefix(path, http.FileServer(root))

	if path != "/" && path[len(path)-1] != '/' {
		r.Get(path, http.RedirectHandler(path+"/", 301).ServeHTTP)
		path += "/"
	}
	path += "*"

	r.Get(path, http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		fs.ServeHTTP(w, r)
	}))

	r.Get("/ping", http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("pong"))
	}))

}

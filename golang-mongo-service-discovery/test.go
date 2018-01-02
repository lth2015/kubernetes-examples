package main

import (
	"fmt"
	"gopkg.in/mgo.v2"
	"gopkg.in/mgo.v2/bson"
	"log"
	"os"
)

type Person struct {
	Name  string
	Phone string
}

func main() {
	svc := os.Getenv("MONGO_SVC_SERVICE_HOST")
	port := os.Getenv("MONGO_SVC_SERVICE_PORT")
	fmt.Println("Server: ", svc, ", Port: ", port)

	session, err := mgo.Dial("mongo-svc.default")
	if err != nil {
		panic(err)
	}
	defer session.Close()

	// Optional. Switch the session to a monotonic behavior.
	session.SetMode(mgo.Monotonic, true)

	c := session.DB("test").C("Person")
	err = c.Insert(&Person{"Dawei", "+86 01 18910648861"},
		&Person{"Litanhua", "+86 01 18604821955"})
	if err != nil {
		log.Fatal(err)
	}

	result := Person{}
	err = c.Find(bson.M{"name": "Litanhua"}).One(&result)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println("Phone:", result.Phone)
	fmt.Println("Hello world!")
}

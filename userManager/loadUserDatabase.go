package main

import (
	"fmt"
	"os"
	"io/ioutil"
	"net/http"
	"strings"
	"strconv"

	"github.com/losfair/urlencoder-go/urlencoder"
)

type UserDetail struct {
	Port string
	Password string
}

func getUsage() string {
	return "Usage: loadUserDatabase [path to database file] [ssplus api addr] [ssplus api key]"
}

func addUser(apiAddr,apiKey,port,pw string) {
	reqStr := fmt.Sprintf("http://%s/%s/addUser/port=%s&pw=%s",apiAddr,apiKey,urlencoder.EncodeComponent(port),urlencoder.EncodeComponent(pw))
	resp,err := http.Get(reqStr)
	if err!=nil {
		panic(err)
	}

	defer resp.Body.Close()
	data,err := ioutil.ReadAll(resp.Body)
	if err!=nil {
		panic(err)
	}

	fmt.Println("[api]",string(data))
}

func main() {
	if len(os.Args)<4 {
		panic(getUsage())
	}

	fmt.Printf("Reading database... ")
	os.Stdout.Sync()

	userDatabaseName := os.Args[1]
	userData,err := ioutil.ReadFile(userDatabaseName)
	if err!=nil {
		panic(err)
	}

	userLines := strings.Split(strings.TrimSpace(string(userData)),"\n")
	userCfg := make(map[string]UserDetail)

	for lineId,line := range userLines {
		lineParts := strings.SplitN(strings.TrimSpace(line),":",3)
		if len(lineParts)!=3 {
			panic("Illegal configuration at line "+strconv.Itoa(lineId+1))
		}
		userCfg[lineParts[0]] = UserDetail {
			Port: lineParts[1],
			Password: lineParts[2],
		}
	}

	fmt.Println("Done.")

	fmt.Println("Adding users via API")

	apiAddr := os.Args[2]
	apiKey := os.Args[3]

	for name,detail := range userCfg {
		fmt.Printf("%s: ",name)
		os.Stdout.Sync()
		addUser(apiAddr,apiKey,detail.Port,detail.Password)
	}

	fmt.Println("Done.")
}

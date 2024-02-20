// check-korean.go
package main

import (
	"bufio"
	"flag"
	"fmt"
	"os"
	"regexp"
)

func main() {
	flag.Parse()
	files := flag.Args()

	re := regexp.MustCompile("[\uAC00-\uD7A3]+")
	for _, file := range files {
		f, err := os.Open(file)
		if err != nil {
			fmt.Printf("Failed to open file: %s, err: %v\n", file, err)
			continue
		}
		defer f.Close()

		scanner := bufio.NewScanner(f)
		lineNumber := 1 // Track the line number

		for scanner.Scan() {
			if re.MatchString(scanner.Text()) {
				// fmt.Printf("Korean characters found in file: %s\n", file)
				fmt.Printf("Line %d: %s\n", lineNumber, scanner.Text())
			}
			lineNumber++ // Increment the line number
		}
	}
}

package main
import (
	"log"
	"os"
	"github.com/signintech/gopdf"
)

func main() {
	pdf := gopdf.GoPdf{}
	pdf.Start(gopdf.Config{ PageSize: *gopdf.PageSizeA4 })  
	pdf.AddPage()
	err := pdf.AddTTFFont("wts11", os.Args[1])
	if err != nil {
		log.Print(err.Error())
		return
	}
	return

}

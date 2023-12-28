package main

import (
	"context"
	"fmt"
	"golang.org/x/sync/errgroup"
	"log"
	"net/http"
	"net/url"
	"os"
	"os/signal"
	"time"
)

// This package is a utility to verify that this capability correctly configures a Fargate service to scale when request minimum is reached

const (
	requestHost       = "images.dev.fayde.io"
	runDuration       = 10 * time.Second
	numRequestsPerRun = 1000
	sustainFor        = 3 * time.Minute
)

func main() {
	u := &url.URL{
		Scheme: "https",
		Host:   requestHost,
		Path:   "/",
	}

	grp, ctx := errgroup.WithContext(context.Background())
	signal.NotifyContext(ctx, os.Interrupt, os.Kill)
	done := make(chan struct{})
	go func() {
		for i := 0; ; i++ {
			iterStart := time.Now()
			fmt.Printf("running iteration %d\n", i)

			for ii := 0; ii < numRequestsPerRun; ii++ {
				go func() {
					grp.Go(func() error {
						req, _ := http.NewRequestWithContext(ctx, http.MethodGet, u.String(), nil)
						_, err := http.DefaultClient.Do(req)
						return err
					})
				}()
			}

			sleepTime := time.Now().Sub(iterStart)
			if sleepTime > runDuration {
				continue
			}
			select {
			case <-done:
				return
			case <-ctx.Done():
				return
			case <-time.After(runDuration - sleepTime):
			}
		}
	}()

	select {
	case <-time.After(sustainFor):
	case <-ctx.Done():
	}
	close(done)
	if err := grp.Wait(); err != nil {
		log.Fatalln(err)
	}
}

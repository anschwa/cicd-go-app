package main

import (
	"encoding/json"
	"io/ioutil"
	"net/http/httptest"
	"os"
	"testing"
)

func TestNewHandler(t *testing.T) {
	want := Status{
		Env:     "production",
		Version: "v1.0.1",
	}

	if err := os.Setenv("APP_ENV", want.Env); err != nil {
		t.Errorf("error setting APP_ENV: %w", err)
	}

	// Setup test server
	h := NewHandler()
	ts := httptest.NewServer(h)
	defer ts.Close()

	client := ts.Client()
	resp, err := client.Get(ts.URL)
	if err != nil {
		t.Errorf("error getting response: %w", err)
	}

	body, err := ioutil.ReadAll(resp.Body)
	resp.Body.Close()
	if err != nil {
		t.Errorf("error reading response body: %w", err)
	}

	var got Status
	err = json.Unmarshal(body, &got)
	if err != nil {
		t.Errorf("error umarshalling json: %w", err)
	}

	// Check results
	if want.Env != got.Env || want.Version != got.Version {
		t.Errorf("\nwant:\t%q\ngot:\t%q", want, got)
	}
}

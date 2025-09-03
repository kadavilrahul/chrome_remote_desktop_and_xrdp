package ui

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"

	"github.com/fatih/color"
)

type MenuItem struct {
	ID          int
	Description string
	Action      func() error
}

type Menu struct {
	title string
	items []MenuItem
}

func NewMenu(title string) *Menu {
	return &Menu{
		title: title,
		items: make([]MenuItem, 0),
	}
}

func (m *Menu) AddItem(id int, description string, action func() error) {
	m.items = append(m.items, MenuItem{
		ID:          id,
		Description: description,
		Action:      action,
	})
}

func (m *Menu) Show() error {
	for {
		m.clear()
		m.drawBox()

		choice, err := m.getChoice()
		if err != nil {
			fmt.Printf("Invalid input: %v\n", err)
			m.waitForEnter()
			continue
		}

		if choice == 0 {
			fmt.Println("\nThank you for using Chrome Remote Desktop Setup!")
			return nil
		}

		found := false
		for _, item := range m.items {
			if item.ID == choice {
				found = true
				fmt.Printf("\n%s\n", color.BlueString("Running: %s", item.Description))
				fmt.Println("----------------------------------------")

				if err := item.Action(); err != nil {
					fmt.Printf("\n%s\n", color.RedString("✗ Error: %v", err))
				} else {
					fmt.Printf("\n%s\n", color.GreenString("✓ %s completed successfully!", item.Description))
				}
				m.waitForEnter()
				break
			}
		}

		if !found {
			fmt.Printf("%s\n", color.RedString("Invalid option. Please try again."))
			m.waitForEnter()
		}
	}
}

func (m *Menu) clear() {
	fmt.Print("\033[2J\033[H")
}

func (m *Menu) drawBox() {
	fmt.Println()
	m.drawBoxLine(m.title)
	fmt.Println()

	fmt.Printf("%s\n\n", color.WhiteString("Choose an option:"))

	for _, item := range m.items {
		fmt.Printf("%s %s\n",
			color.GreenString("%d)", item.ID),
			color.WhiteString(item.Description))
	}

	fmt.Printf("%s %s\n",
		color.RedString("0)"),
		color.WhiteString("Exit"))

	fmt.Printf("\n%s", color.YellowString("Enter your choice: "))
}

func (m *Menu) drawBoxLine(text string) {
	cyan := color.New(color.FgCyan)
	length := len(text)
	padding := 4
	totalWidth := length + padding

	cyan.Print("╔")
	for i := 0; i < totalWidth; i++ {
		cyan.Print("═")
	}
	cyan.Print("╗")
	fmt.Println()

	cyan.Printf("║  %-*s  ║\n", length, text)

	cyan.Print("╚")
	for i := 0; i < totalWidth; i++ {
		cyan.Print("═")
	}
	cyan.Print("╝")
	fmt.Println()
}

func (m *Menu) getChoice() (int, error) {
	reader := bufio.NewReader(os.Stdin)
	input, err := reader.ReadString('\n')
	if err != nil {
		return 0, err
	}

	input = strings.TrimSpace(input)
	choice, err := strconv.Atoi(input)
	if err != nil {
		return 0, fmt.Errorf("invalid number: %s", input)
	}

	return choice, nil
}

func (m *Menu) waitForEnter() {
	fmt.Print("\nPress Enter to continue...")
	bufio.NewReader(os.Stdin).ReadBytes('\n')
}

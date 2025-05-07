#!/bin/python3
import pyautogui
import time
import sys
import pyperclip

time.sleep(2)

if len(sys.argv) > 1:
    print("Printing...")
    pyautogui.typewrite(sys.argv[1])
else:
    print("Input not found, printing from clipboard...")
    pyautogui.typewrite(pyperclip.paste())

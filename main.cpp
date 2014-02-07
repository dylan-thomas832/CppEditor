/*
 * File main.cpp
 * Project: Project 4
 * Title: Text Editor
 * Author: Dylan Thomas
 * 
 * This file allows a user to load a file. The file prints with a cursor. The 
 * user can move the cursor, erase characters, insert characters. Save the file
 * as an existing or new file. And then the user can quit the text editor by
 * command. This main file contains the initial prompt, determining the user's
 * command input, and executing the command while the user still wishes to.
 */


#include <iostream>
#include "editor.h"
#include <istream>
#include <fstream>
#include <iomanip>
#include <string>
#include <vector>
#include <climits>

using namespace std;


int main() 
{
    cout << "Welcome to the CS1044 Text Editor\n";
    string cmmd; //Command user inputs
    editor_file current_file;
    
    // Loop stays open while the command is not "quit"
    while(true)
    {
        cout << ">";
        cin >> cmmd;
        // No command is allowed except for open at first
        if (current_file.is_open == false && cmmd != "open")
        {
            cout << "No file is currently open\n";
            cout << "To open a file enter: open <filename>\n>";
        }
        
        /*
         * Each if statement is to determine the inputted command. Then it 
         * calls that command and outputs the text file.
         */
        
        else if (cmmd == "open") // Opens file to edit
        {
            open(current_file);
            cout << current_file;
        }
        else if (cmmd == "move") //Moves cursor through the text file
        {
            move(current_file); 
            cout << current_file;
        }
        else if (cmmd == "insert") //Inserts a character at the cursor position
        {
            insert(current_file);
            cout << current_file;
        }
        else if (cmmd == "erase") //Erases single character at cursor position
        {
            erase(current_file);
            cout << current_file;
        }
        else if (cmmd == "saveas") //Saves the new text file
        {
            saveas(current_file); 
            cout << current_file;
        }
        else if (cmmd == "quit") //Quits the Text Editor
        {
            quit(current_file);
            break; //Breaks the while loop to terminate the program
        }
        else // Error printed for nonsensical commands after file is opened
        {
            cout << "That's not an editor's command.\n";
        }
        
        /* 
         * Ignores any other erroneous inputs past the specific commands 
         * and parameters.
         */
        cin.ignore(INT_MAX, '\n');
    }
    
    return 0;
}


/*
 * File: editor.cpp
 * Project: Project 4
 * Title: Text Editor
 * Author: Dylan Thomas
 * 
 * This file contains the function definitions for the main.cpp "Text Editor"
 * program. All the functions called from main.cpp are defined here. 
 */


#include <iostream>
#include "editor.h"
#include <fstream>
#include <istream>
#include <iomanip>
#include <vector>
#include <string>

using namespace std;

/**
 * 
 * Opens the file with the specified filename and makes it the current file
 */
void open(editor_file &file)
{
    string filename;
    cin >> filename; 
    file.name = filename; //Saves the filename in the custom structure
    
    // Opens a new input file stream to read
    ifstream text(file.name.c_str());
    string line; //Current line read from input file stream
    
    // Checks to make sure the file is openable or exists
    if (text) 
    {
        getline(text,line); // Opens while loop
        
        // Iteratively reads text file line by line
        while(text)
        {
            // Removes the carriage return that getline adds to each line
            if (line[line.size() - 1] == '\r')
            {
                line.erase(line.size() - 1);
            }
            
            // Adds the line to a string in the custom structure
            file.data += line + '\n';
            
            /* Reads data for next loop*/
            getline(text,line);
        }
        file.is_open = true;
        file.is_saved = false;
    }
    else //If the file won't open
    {
        //Error message
        cout << "Could not open '";
        cout << file.name;
        cout << "'. Try a different file\n>";
        file.is_open = false;
        file.is_saved = false;
    }
    text.close(); //Closes input file stream
}

/**
 * 
 * Inserts a character in the file at the cursor postion
 */
void insert(editor_file &file)
{
    char new_char;
    cin >> new_char; //Retrieves character to insert into text file
    
    // Inserts the character using the current cursor position
    file.data.insert(file.data.begin() + file.cursor, new_char);
    file.is_saved = false;
}

/**
 * 
 * Deletes a single char at the cursor location
 */
void erase(editor_file &file)
{
    // Erases a single character at the current position of the cursor
    file.data.erase(file.data.begin() + file.cursor);
    file.is_saved = false;
}

/**
 * 
 * Moves the "cursor" in the file. If the index is out range (bigger than the 
 * file or negative) an error message is printed.
 */
void move(editor_file &file)
{
    int position;
    cin >> position; //Retrieves position to move the cursor to
    
    /*
     * Checks if the position to move the cursor to is in the range of the 
     * string's length.
     */
    if (position > file.data.size() || position < 0)
    {
        cout << "Invalid Cursor Entry\n"; //Error message
    }
    else
    {
        file.cursor = position;
    }
}

/**
 * 
 * Saves the current file with the specified filename.
 */
void saveas(editor_file &file)
{
    string filename;
    
    // User enters filename to save the new text file as
    cout << "Enter filename: ";
    cin >> filename;
    
    // Outputs the stream to a file
    ofstream savedata(filename.c_str());
    savedata << file.data;
    file.is_saved = true;
}

/**
 * 
 * Terminates the program. If the file is modified and hasn't been saved, 
 * the user is prompted to the save the changes to another file.
 */
void quit(editor_file &file)
{
    string ans;
    // Checks if the file is saved
    if (file.is_saved == false)
    {
        /* 
         * If not, user is prompted by asking if he/she wishes to save the 
         * current text file or not
         */
        cout << "Would you like to save before you exit? (Y/N): ";
        cin >> ans;
        if (ans == "Y" || ans == "y")
        {
            saveas(file); //Calls the save function if the user answers yes
        }
    }
    file.is_open = false; //File is not closed
}


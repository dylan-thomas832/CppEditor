
#ifndef EDITOR_H
#define	EDITOR_H

#include <string>
#include <ostream>
#include <iomanip>
#include <fstream>

/* this represents a file in our editor*/
struct editor_file
{
        /* the files name */
        std::string name;
        /* the text inside of the file */
        std::string data;

        /* the cursor position in the file */
        int cursor;

        /* tells you if the file is open */
        /* by default the file isn't open */
        bool is_open;
        
        /* tells you if the file is saved */
        /* by default it is "saved" */
        bool is_saved;

        /* IGNORE ME: initializes the struct with default values */
        editor_file():cursor(0),is_open(false), is_saved(true) {}
};

/**
 * 
 * This prints the editor_file type as shown in the specs
 * 
 */
inline std::ostream& operator<<(std::ostream& stream, const editor_file& file)
{
        int begin, end;
        int curr_char = 0;

        /* print all the data */
        while(curr_char < file.data.size())
        {
                std::string line = "";

                begin = curr_char;

                /* print each line in the file */
                while(file.data[curr_char] != '\n')
                {
                        line += file.data[curr_char];
                        curr_char++;
                }

                /* by default make a 60 char space for the line */
                stream << std::left << std::setw(60) << line;
                end = curr_char;

                /* print the index numbers for the */ 
                /* beginning and end of the line */
                stream << "|" << begin << ":" << end << "|";
                stream << file.data[curr_char];
                curr_char++;

                /* this prints the line with cursor on it */
                if((begin <= file.cursor) && (file.cursor <= end))
                {
                        for(int c = begin; c <= end; c++)
                        {
                                if(c == file.cursor)
                                {
                                        stream << "^";
                                }
                                else
                                {
                                        stream << " ";
                                }
                        }
                        stream << std::endl;
                }

        }

        return stream;
}

/**
 * 
 * Opens the file with the specified filename and makes it the current file
 */
void open(editor_file &file);

/**
 * 
 * Inserts a character in the file at the cursor postion
 */
void insert(editor_file &file);


/**
 * 
 * Deletes a single char at the cursor location
 */
void erase(editor_file &file);

/**
 * 
 * Moves the "cursor" in the file. If the index is out range (bigger than the 
 * file or negative) an error message is printed.
 */
void move(editor_file &file);

/**
 * 
 * Saves the current file with the specified filename.
 */
void saveas(editor_file &file);

/**
 * 
 * Terminates the program. If the file is modified and hasn't been saved, 
 * the user is prompted to the save the changes to another file.
 */
void quit(editor_file &file);




#endif	/* EDITOR_H */


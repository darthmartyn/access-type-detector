with Ada.Text_IO;       use Ada.Text_IO;
with Ada.Directories;   use Ada.Directories;
with Ada.Strings;       use Ada.Strings;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with Ada.IO_Exceptions;

procedure ptrfinder2 is
begin

   Read_Standard_Input:
   while not End_Of_File(Standard_Input)
   loop

      Process_Standard_Input:
      declare

         Std_Input : constant String := Get_Line;
         Delimeter_Position : constant Natural := Index(Std_Input,":");
         Line_Number_As_String : constant String :=  Std_Input(Delimeter_Position+1..Std_Input'Last);
         Line_Number : constant Integer := Integer'Value(Line_Number_As_String);
         Filename : constant String := Std_Input(Std_Input'First..Delimeter_Position-1);
         The_File : File_Type;
         Verified : Boolean := False;

      begin

         if Ada.Directories.Exists(Filename) and then Line_Number > 1
         then

            Open(File => The_File, Mode => In_File, Name => Filename);

            Locate_Line:
            for I in 1..Line_Number loop

               Verified := Index(Get_Line(The_File)," access ") > 0;

               exit when Verified or else End_Of_File(The_File);

            end loop Locate_Line;

            Close(File => The_File);

         end if;

         if Verified then
            Put_Line("Access Type Verified on line #" & Line_Number_As_String & " of " & Filename);
         else
            Put_Line("Suspected Access Type *NOT* Verified on line #" & Line_Number_As_String & " of " & Filename);
         end if;

      end Process_Standard_Input;

   end loop Read_Standard_Input;

end ptrfinder2;

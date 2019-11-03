with Ada.Text_IO;         use Ada.Text_IO;
with Libadalang.Analysis; use Libadalang.Analysis;
with Libadalang.Common;   use Libadalang.Common;
with Ada.Strings.Fixed;
with Ada.Strings;

procedure ptrfinder1 is

   LAL_CTX  : constant Analysis_Context := Create_Context;

begin

   Read_Standard_Input:
   while not End_Of_File(Standard_Input)
   loop

      Process_Ada_Unit:
      declare

         Filename : constant String := Get_Line;

         Unit : constant Analysis_Unit := LAL_CTX.Get_From_File(Filename);

         function Process_Node(Node : Ada_Node'Class) return Visit_Status is
         begin

           if Node.Kind in Ada_Access_Def
                         | Ada_Access_To_Subp_Def_Range
                         | Ada_Base_Type_Access_Def
                         | Ada_Anonymous_Type_Access_Def_Range
                         | Ada_Type_Access_Def_Range
           then
              Put_Line(
                 Ada.Strings.Fixed.Trim(
                    Source => Filename & ":" & Node.Sloc_Range.Start_Line'Img,
                    Side  => Ada.Strings.Left
                 )
              );
           end if;

           return Into;

         end Process_Node;

      begin

         if not Unit.Has_Diagnostics then
            Unit.Root.Traverse(Process_Node'Access);
         end if;

      end Process_Ada_Unit;

   end loop Read_Standard_Input;

end ptrfinder1;

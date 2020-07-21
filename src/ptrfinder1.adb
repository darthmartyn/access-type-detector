with Ada.Text_IO;           use Ada.Text_IO;
with Libadalang.Analysis;   use Libadalang.Analysis;
with Libadalang.Common;     use Libadalang.Common;
with Ada.Strings.Fixed;     use Ada.Strings.Fixed;
with Ada.Strings;           use Ada.Strings;
with Langkit_Support.Slocs; use Langkit_Support.Slocs;

procedure ptrfinder1 is

   procedure Detection
     (Filename    : String;
      Line_Number : Langkit_Support.Slocs.Line_Number)
   is
      The_Filename : constant String := Trim (Filename,Ada.Strings.Left);
      The_Line_Number : constant String := Trim (Line_Number'Img,Ada.Strings.Left);
   begin
      Put_Line (The_Filename & ":" & The_Line_Number);
   end Detection;

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

            case Node.Kind is

               when Ada_Base_Type_Decl =>

                  if Node.As_Base_Type_Decl.P_Is_Access_Type then

                     Detection (Filename,Node.Sloc_Range.Start_Line);

                  end if;

               when Ada_Object_Decl =>

                  if Node.As_Object_Decl.F_Type_Expr.
                       P_Designated_Type_Decl.P_Is_Access_Type then

                    Detection (Filename,Node.Sloc_Range.Start_Line);

                  end if;

               when others =>

                  return Into;
                  --   Nothing interesting was found in this Node so
                  --   continue processing it for other violations

            end case;

            return Over;
            --   A violation was detected,  skip over any further processing
            --   of this Node.

         end Process_Node;

      begin

         if not Unit.Has_Diagnostics then
            Unit.Root.Traverse (Process_Node'Access);
         end if;

      end Process_Ada_Unit;

   end loop Read_Standard_Input;

end ptrfinder1;

with Ada.Text_IO;           use Ada.Text_IO;
with Libadalang.Analysis;   use Libadalang.Analysis;
with Libadalang.Common;     use Libadalang.Common;
with Ada.Strings.Fixed;     use Ada.Strings.Fixed;
with Ada.Strings;           use Ada.Strings;
with Langkit_Support.Slocs; use Langkit_Support.Slocs;

procedure ptrfinder1 is

   procedure Detection
     (Filename    : String;
      Line_Number : Langkit_Support.Slocs.Line_Number) is
   begin
      Put_Line (Trim(Filename & ":" & Line_Number'Img,Left));
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

               when Ada_Object_Decl =>
               --  Object of Access Type

                  if Node.As_Object_Decl.F_Type_Expr.
                       P_Designated_Type_Decl.P_Is_Access_Type then
                    Detection (Filename,Node.Sloc_Range.Start_Line);
                  end if;

               when Ada_Access_To_Subp_Def =>
               --  Access to subprogram

                  Detection (Filename,Node.Sloc_Range.Start_Line);

               when Ada_Type_Access_Def =>
               -- Access Types

                  Detection (Filename,Node.Sloc_Range.Start_Line);

               when Ada_Anonymous_Type_Access_Def =>
               -- Anonymous Access Type

                  Detection (Filename,Node.Sloc_Range.Start_Line);

               when Ada_Subtype_Decl =>
               -- Could be a subtype of an Access Type

                  if Node.As_Subtype_Decl.P_Is_Access_Type then
                     Detection (Filename,Node.Sloc_Range.Start_Line);
                  end if;

               when Ada_Derived_Type_Def =>
               -- Could be derived from an Access Type

                  if Node.Parent.As_Type_Decl.P_Is_Access_Type then
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
            Unit.Root.Traverse(Process_Node'Access);
         end if;

      end Process_Ada_Unit;

   end loop Read_Standard_Input;

end ptrfinder1;

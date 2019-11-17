procedure Basic_Pointers is

   type General_Purpose_Ptr is access all Integer;  --  DETECTED ?

   type Pool_Specific_Ptr is access all Float;  --  DETECTED ?

begin

   null;

end Basic_Pointers;

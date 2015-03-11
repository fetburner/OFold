let width = ref 80
let filenames = ref []

let spec =
  [("--width",
    Arg.Int (fun w -> width := w),
    "Specify a line width to use instead of the default 80 columns")]

let size_of_char = function
  | '\t' -> 8
  | _ -> 1

let () =
  Arg.parse spec
    (fun s -> filenames := s :: !filenames)
    "Usage: fold [--width width] [-help] filename ...";
  List.iter
    (fun filename ->
      let channel = open_in filename in
      let current_width = ref 0 in
      (try
        while true do
          let c = input_char channel in
          if !current_width >= !width then begin
            current_width := 0;
            print_newline ()
          end;
          if c = '\n' then
            current_width := 0;
          print_char c;
          current_width := !current_width + size_of_char c
        done;
      with End_of_file -> ());
      close_in channel)
    (List.rev !filenames)

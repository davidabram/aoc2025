let coc_size = 100

let rotate (pos, dir, steps) =
  let steps = steps mod coc_size in
  match dir with
  | 'R' ->
      let pos' = pos + steps in
      if pos' >= coc_size then pos' - coc_size else pos'
  | 'L' ->
      let pos' = pos - steps in
      if pos' < 0 then pos' + coc_size else pos'
  | _ -> invalid_arg "A hwat?"

let parse_move (line) = Scanf.sscanf line " %c%d" (fun dir n -> (dir, n))

let process_move (pos, count) (dir, n) =
  let pos' = rotate (pos, dir, n) in
  let count' = match pos' with
    | 0 -> count + 1
    | _ -> count
  in
  (pos', count')

let lines ic : string Seq.t =
  let next () =
    match input_line ic with
    | line -> Some (line, ())
    | exception End_of_file -> None
  in
  Seq.unfold next ()

let () =
  let moves =
    lines stdin |> Seq.filter ((<>) "") |> Seq.map parse_move
  in
  let _, count = Seq.fold_left process_move (50, 0) moves in
  Printf.printf "%d\n" count

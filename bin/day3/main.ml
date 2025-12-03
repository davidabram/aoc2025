module Logic = struct
  let digits_of_string (s : string) : int list =
    s
    |> String.to_seq
    |> Seq.map (fun c -> Char.code c - Char.code '0')
    |> List.of_seq

  let best_two_digits (s : string) : int =
    let digits = digits_of_string s in
    let _, best =
      List.fold_right
        (fun d (max_right_opt, best) ->
           let best' =
             match max_right_opt with
             | None ->
                 best
             | Some mr ->
                 let v = 10 * d + mr in
                 if v > best then v else best
           in
           let max_right' =
             match max_right_opt with
             | None -> Some d
             | Some mr -> Some (if d > mr then d else mr)
           in
           (max_right', best'))
        digits
        (None, 0)
    in
    best
end

let sum_int64_seq (xs : int Seq.t) : int64 =
  let open Int64 in
  xs
  |> Seq.fold_left (fun acc x -> add acc (of_int x)) 0L

let read_lines_seq () : string Seq.t =
  let next ic =
    match input_line ic with
    | line -> Some (line, ic)
    | exception End_of_file -> None
  in
  Seq.unfold next stdin

let solve (banks : string Seq.t) : int64 =
  banks
  |> Seq.filter ((<>) "")
  |> Seq.map Logic.best_two_digits
  |> sum_int64_seq

let () =
  read_lines_seq ()
  |> solve
  |> Int64.to_string
  |> print_endline


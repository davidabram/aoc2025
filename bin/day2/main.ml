let pow10 n = Int64.of_float (10.0 ** float_of_int n)

let count_digits n =
  match n with 0L -> 1 | _ -> 1 + int_of_float (log10 (Int64.to_float n))

let make_invalid_id pattern =
  let num_digits = count_digits pattern in
  let shift = pow10 num_digits in
  Int64.(add (mul pattern shift) pattern)

let int64_range start end_inclusive =
  Seq.unfold
    (fun current ->
      match current > end_inclusive with
      | true -> None
      | false -> Some (current, Int64.succ current))
    start

let generate_invalid_ids_in_range (a, b) =
  let max_digits = count_digits b in
  Seq.iterate (fun len -> len + 1) 1
  |> Seq.take_while (fun len -> len * 2 <= max_digits)
  |> Seq.flat_map (fun len ->
      let shift = pow10 len in
      let divisor = Int64.add shift 1L in
      let min_pattern =
        let p = Int64.div a divisor in
        let min_for_len = match len with 1 -> 1L | _ -> pow10 (len - 1) in
        max min_for_len p
      in
      let max_pattern =
        let p = Int64.div b divisor in
        let max_for_len = Int64.sub (pow10 len) 1L in
        min max_for_len (Int64.add p 1L)
      in
      match min_pattern <= max_pattern with
      | false -> Seq.empty
      | true ->
          int64_range min_pattern max_pattern
          |> Seq.map make_invalid_id
          |> Seq.filter (fun n -> n >= a && n <= b))

let solve ranges =
  ranges |> List.to_seq
  |> Seq.map (fun range ->
      generate_invalid_ids_in_range range |> Seq.fold_left Int64.add 0L)
  |> Seq.fold_left Int64.add 0L

let parse_range s =
  match String.split_on_char '-' s with
  | [ a; b ] -> (Int64.of_string a, Int64.of_string b)
  | _ -> failwith ("bad range: " ^ s)

let parse_input input =
  String.split_on_char ',' input
  |> List.filter (fun s -> String.length s > 0)
  |> List.map parse_range

let () =
  In_channel.input_line In_channel.stdin
  |> Option.get |> parse_input |> solve |> Printf.printf "%Ld\n"

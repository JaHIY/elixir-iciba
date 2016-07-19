defmodule ICIBA.CLI do

  @default_args [
    color: true,
  ]

  defp parse_args(args) do
    OptionParser.parse!(
      args,
      aliases: [
        h: :help,
        c: :color,
      ],
      strict: [
        help: :boolean,
        color: :boolean,
      ]
    )
  end

  defp get_word_text(word, opts) do
    {
      :ok,
      %{
        "word_name" => name,
        "exchange" => exchange,
        "symbols" => symbols,
      }
    } = ICIBA.Dictionary.look_up(word)

    [
     get_name_text(name),
     get_symbols_text(symbols),
     get_exchange_text(exchange),
    ]
      |> Enum.concat
      |> Enum.filter(&(not Enum.empty?(&1)))
      |> Enum.intersperse(["\n\n"])
      |> Enum.concat
      |> IO.ANSI.format(opts[:color])
  end

  defp get_name_text(name) do
    [
      [
        :yellow,
        :bright,
        name,
        :reset,
      ]
    ]
  end

  defp get_symbols_text(symbols) do
    symbols
      |> Enum.flat_map(
        fn(
          %{
            "ph_en" => ph_en,
            "ph_am" => ph_am,
            "ph_other" => ph_other,
            "parts" => parts,
          }
        ) ->
          ph = %{"US" => ph_am, "UK" => ph_en, "OT" => ph_other}
                |> Enum.filter_map(
                  fn({_k, v}) ->
                    String.length(v) > 0
                  end,
                  fn({k, v}) ->
                    [
                      String.duplicate(" ", 2),
                      k |> String.pad_trailing(3),
                      " [", :yellow, v, :reset, "]",
                    ]
                  end
                )
                |> Enum.intersperse(["\n"])
                |> Enum.concat

          ph_result = case ph do
            []       -> ph
            [_ | _]  ->
              [
                [
                  :cyan,
                  "Pronunciation:",
                  :reset,
                ],

                ph
              ]
              |> Enum.intersperse(["\n"])
              |> Enum.concat
          end

          exp = parts
                |> Enum.map(
                  fn(
                    %{
                      "means" => means,
                      "part" => part,
                    }
                  ) ->
                    [
                      String.duplicate(" ", 2),
                      :yellow,
                      part |> String.pad_trailing(4),
                      :reset,
                      means |> Enum.join("；")
                    ]
                  end
                )
                |> Enum.intersperse(["\n"])
                |> Enum.concat

          exp_result = case exp do
            []      -> exp
            [_ | _] ->
              [
                [
                  :cyan,
                  "Explanation:",
                  :reset,
                ],

                exp

              ]
                |> Enum.intersperse(["\n"])
                |> Enum.concat
          end

          [
            ph_result,
            exp_result,
          ]
        end
      )
  end

  defp get_exchange_text(exchange) do
    result = exchange
      |> Enum.filter_map(
        fn({_k, v}) -> is_list(v) end,
        fn({k, v}) ->
          [
            String.duplicate(" ", 2),
            :yellow,
            k |> String.replace_prefix("word_", "-") |> String.pad_trailing(8),
            :reset,
            Enum.join(v, ", "),
          ]
        end
      )
      |> Enum.intersperse(["\n"])
      |> Enum.concat

    [
      case result do
        []       -> result
        [_ | _]  ->
          [
            [
              :cyan,
              "Exchange:",
              :reset,
            ],

            result

          ]
            |> Enum.intersperse(["\n"])
            |> Enum.concat
      end
    ]
  end

  defp look_up_words(word_list, opts) do
    look_up_words(word_list, opts, [])
  end

  defp look_up_words([], _opts, word_text_list) do
    word_text_list |> Enum.reverse |> Enum.join("\n\n")
  end

  defp look_up_words([head | tail], opts, word_text_list) do
    look_up_words(tail, opts, [get_word_text(head, opts) | word_text_list])
  end

  defp do_process({parsed, remaining}) do
    look_up_words(remaining, Enum.concat(parsed, @default_args)) |> IO.puts
  end

  def main(args) do
    args |> parse_args |> do_process
  end

end

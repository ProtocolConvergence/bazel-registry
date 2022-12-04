def _cc_parsing_expression_grammar_impl(ctx):
  leg_file = ctx.file.src
  cc_file = None
  if ctx.outputs.out_cc:
    cc_file = ctx.outputs.out_cc
  else:
    cc_file = ctx.actions.declare_file(ctx.label.name + ".cc")

  outfiles = [cc_file]

  # Translate to textproto.
  args = ctx.actions.args()
  args.add("-P")
  args.add("-o")
  args.add(cc_file)
  args.add(leg_file)
  ctx.actions.run(
      executable = ctx.executable._leg,
      arguments = [args],
      inputs = [leg_file],
      outputs = [cc_file],
   )

  return DefaultInfo(
      files = depset([cc_file]),
      runfiles = ctx.runfiles(files = [cc_file]),
  )


cc_parsing_expression_grammar = rule(
    implementation = _cc_parsing_expression_grammar_impl,
    attrs = {
        "src": attr.label(
            mandatory = True,
            allow_single_file = True,
            doc = "The .leg file to compile.",
        ),
        "out_cc": attr.output(
            mandatory = False,
            doc = "The .cc file to write.",
        ),
        "_leg": attr.label(
            default = Label("//:leg"),
            allow_single_file = True,
            executable = True,
            cfg = "exec",
        ),
    },
)

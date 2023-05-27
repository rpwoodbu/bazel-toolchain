load("//toolchain:rules.bzl", "llvm_toolchain")

def _toolchain_impl(ctx):
    for mod in ctx.modules:
        for llvm in mod.tags.llvm:
            llvm_toolchain(
                # TODO: Since each toolchain has to be its own repo, specifying
                # a single name precludes having more than one `llvm` tag, thus
                # we cannot define more than one toolchain. But this name must
                # be hard-coded into `MODULES.bazel`, so we can only have one
                # name. A new mechanism for specifying multiple toolchains into
                # a single repo is probably required, ala `rules_go`.
                name = "bzlmod_toolchain",
                llvm_version = llvm.llvm_version,
                sysroot = llvm.sysroot,
            )

_llvm = tag_class(
    attrs = {
        "name": attr.string(),
        "llvm_version": attr.string(),
        "sysroot": attr.string_dict(),
    },
)

toolchain = module_extension(
    implementation = _toolchain_impl,
    tag_classes = {"llvm": _llvm},
)

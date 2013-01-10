module SQLAnywhere::LibC
  extend FFI::Library
  ffi_lib FFI::Library::LIBC

  attach_function :malloc, [:size_t], :pointer
end

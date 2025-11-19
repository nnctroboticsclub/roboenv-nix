function(_list_dep_targets target output_list)
  get_target_property(child_deps ${target} INTERFACE_LINK_LIBRARIES)

  if (NOT child_deps)
    return()
  endif()

  list(APPEND child_deps ${target})
  foreach(dep ${child_deps})
    string(REGEX REPLACE "\\$<LINK_ONLY:([^>]*)>" "\\1" dep ${dep})
    if(NOT ${dep} IN_LIST ${output_list})
      list(APPEND ${output_list} ${dep})
      _list_dep_targets(${dep} ${output_list})
    endif()
  endforeach()

  set(${output_list} ${${output_list}} PARENT_SCOPE)
endfunction()

function(list_dep_targets target output_list)
  _list_dep_targets(${target} ${output_list})
  set(${output_list} ${${output_list}} PARENT_SCOPE)
endfunction()

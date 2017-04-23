function what_is_the_list()
  local L = {}
  L[1+#L] = {"raw-wood", 10}
  L[1+#L] = {"wood", 20}
  L[1+#L] = {"iron-ore", 5}
  L[1+#L] = {"copper-ore", 10}
  return L
end


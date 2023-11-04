local ok, Hydra = pcall(require,'hydra')
if not ok then
  return
end

local ok_splits, splits = pcall(require,'smart-splits')

if not ok_splits then
  return
end

Hydra({
   name = 'Resize',
   config = {
      invoke_on_body = true,
      hint = {
         border = 'rounded',
         offset = -1
      }
   },
   mode = 'n',
   body = '<C-w>',
   heads = {
      { 'h', function() splits.resize_left(2)  end },
      { 'j', function() splits.resize_down(2)  end },
      { 'k', function() splits.resize_up(2)    end },
      { 'l', function() splits.resize_right(2) end },
      { '=', '<C-w>=', { desc = 'equalize'} },
      { '<Esc>', nil,  { exit = true, desc = false }}
   }
})

puts "ECE 260C Lab 4 Test"
puts "Loading technology & design..."
read_liberty sg13g2.lib
read_db jpeg.odb
source setRC.tcl

puts "Initial Undersized Count... (should report 0 undersized cells)"
tee -file results/initial_count.txt { toy_count_undersized }
puts "Removing buffers (done by OpenROAD's rsz, should remove 6727 buffers)..."
remove_buffers
estimate_parasitics -placement
puts "Undersized Count with Buffers Removed... (should report 6481 undersized cells)"
tee -file results/removed_count.txt { toy_count_undersized }

puts "Repairing Once... (should upsize at least 4400 cells)"
tee -file results/repair1.txt { toy_resize }
puts "Undersized Count after One Repair... (should still report over 4500 undersized cells)"
tee -file results/repair1_count.txt { toy_count_undersized }
puts "Repairing Again... (should repair less than 70 cells)"
tee -file results/repair2.txt { toy_resize }

puts "Final Undersized Count... (should be greater than 3900)"
tee -file results/final_count.txt { toy_count_undersized }

puts "Done."
puts "If this was successful, remember to run: make turnin."
class Balrog::ViewGenerator < Rails::Generators::Base

  desc "Copies the Balrog gate view and layout into your application, where you can edit and style them."
  def copy_gate_view
    gate_view = File.open(
      File.join(__dir__, '../../../', 'app/views/balrog/gate.html.erb'),
      'r')

    content = gate_view.read
    gate_view.close

    create_file "app/views/balrog/gate.html.erb", content
  end

  def copy_layout
    gate_view = File.open(
      File.join(__dir__, '../../../', 'app/views/layouts/balrog.html.erb'),
      'r')

    content = gate_view.read
    gate_view.close

    create_file "app/views/layouts/balrog.html.erb", content
  end
end

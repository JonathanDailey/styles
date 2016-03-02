shared_examples "style" do |basename, (filename, path, style, reason), in_dependent_subdir|
  it "must validate against the CSL 1.0.1 schema" do
    expect(CSL.validate(path)).to eq([])
  end

  it "must have a conventional file name" do
    expect(filename).to match(/^[a-z\d]+(-[a-z\d]+)*\.csl$/)
  end

  it "must be parsable as a CSL style" do
    expect(style).to be_a(CSL::Style), reason
  end
  
  unless style.nil?
    if !in_dependent_subdir
      it 'must be an independent style (dependent styles must be placed in the "dependent" subdirectory)' do
        expect(style).to be_independent
      end
    end
    
    if in_dependent_subdir      
      it "must be a dependent style (independent styles must be placed in the root directory)" do
        expect(style).to be_dependent
      end
    end
  end
end

Independents.each_pair do |basename, (filename, path, style, reason)|
  in_dependent_subdir = false
  describe "#{basename}:" do
    include_examples "style", basename, [filename, path, style, reason], in_dependent_subdir
  end
end

Dependents.each_pair do |basename, (filename, path, style, reason)|
  in_dependent_subdir = true
  describe "dependent/#{basename}:" do
    include_examples "style", basename, [filename, path, style, reason], in_dependent_subdir
  end
end

EXE := gen
OBJ_DIR := objs

all: $(EXE)
	ghc -odir $(OBJ_DIR) -tmpdir $(OBJ_DIR) --make gen.hs -o gen

$(EXE) : gen.hs
	@echo Made exe

$(EXE): | $(OBJ_DIR)

$(OBJ_DIR) :
	mkdir $(OBJ_DIR)
	@echo Made object dir


import osrm
import pandas as pd
import numpy as np
from pathlib import Path
from concurrent.futures import ThreadPoolExecutor
import datetime
import logging
logging.getLogger().setLevel(logging.INFO)
#####
# static configs
osrm.RequestConfig.host = "localhost:15000" # runs on port 15000 cause airplay blocks my 5000 port
THIS_DIR = Path(__file__).parent
DATA_DIR = THIS_DIR / "data_aoi"
SPLIT = 1000
DATA_OUT = THIS_DIR / f"data_out_split{SPLIT}"
DATA_OUT.mkdir(parents=True, exist_ok=True)
#####

wenkerAOI = pd.read_csv(DATA_DIR / 'Wenker_places_medium_AOI.csv')
wenker_df = wenkerAOI.drop_duplicates(subset=['gid', 'X', 'Y'])
wenkr_df = wenker_df.sort_values('gid')


def coords_generator(wenker_df, splitted, pos):
    """_summary_

    Args:
        wenker_df (_type_): _description_
        splitted (_type_): _description_
        pos (_type_): _description_

    Yields:
        _type_: _description_
    """
    for cur, i in wenker_df.iterrows():

        yield ([i[["X", "Y"]].values], list(splitted[["X", "Y"]].values), [i["gid"]], list(splitted["gid"].values), cur, pos)


def compute_part_matrix(i):
    """_summary_

    Args:
        i (_type_): _description_

    Returns:
        _type_: _description_
    """
    then = datetime.datetime.now()
    coords_src, coords_dest, ids_origin, ids_dest, cur, pos = i
    logging.info(f"start with {ids_origin[0]} @ {then}")
    time_matrix, snapped_coords, _ = osrm.table(
        coords_src=coords_src, coords_dest=coords_dest, ids_origin=ids_origin, ids_dest=ids_dest, output='dataframe')
    time_matrix = time_matrix/60
    # some folder scatter, so we dont kill the filesystem
    then_folder = then.strftime("%M-%S")
    col = DATA_OUT / f"{then_folder}/{pos}"
    col.mkdir(parents=True, exist_ok=True)
    time_matrix.to_csv(col / f"{ids_origin[0]}-{pos}.csv")
    now = datetime.datetime.now()
    return ids_origin[0], now-then


def run(workers=10):
    with ThreadPoolExecutor(max_workers=workers) as ex:
        for n, splitted in enumerate(np.array_split(wenker_df, SPLIT)):
            for i in ex.map(compute_part_matrix, coords_generator(wenker_df, splitted, n)):
                logging.info(f"done with {i[0]} @ {i[1]}")


if __name__ == "__main__":
    THEN = datetime.datetime.now()
    run()
    NOW = datetime.datetime.now()
    logging.info(f"All in all: {NOW-THEN}")
